## DisableAdaptiveUnity参数

```cpp
        // Engine\Source\Programs\UnrealBuildTool\Configuration\TargetRules.cs
		/// <summary>
		/// Use a heuristic to determine which files are currently being iterated on and exclude them from unity blobs, result in faster
		/// incremental compile times. The current implementation uses the read-only flag to distinguish the working set, assuming that files will
		/// be made writable by the source control system if they are being modified. This is true for Perforce, but not for Git.
		/// </summary>
		[CommandLine("-DisableAdaptiveUnity", Value = "false")]
		[XmlConfigFile(Category = "BuildConfiguration")]
		public bool bUseAdaptiveUnityBuild = true;
```
用一种启发式的方法决定文件是否正在被迭代，如果文件A被迭代，则将其从unity blob文件中（就是每行都是include cpp的文件）移除，文件A被单独编译，unity blob则会跳过编译，从而减少总的编译时间。

对于Perforce工程，判断文件是否被迭代的方法很简单：如果文件是只读的，则认为没被修改；否则，则认为文件被迭代。

### Perforce的判断逻辑
```cpp
    // UnrealBuildTool\Modes\BuildMode.cs
	using (ISourceFileWorkingSet WorkingSet = SourceFileWorkingSet.Create(Unreal.RootDirectory, ProjectDirs, Logger))
    {
        Build(TargetDescriptors, BuildConfiguration, WorkingSet, Options, WriteOutdatedActionsFile, Logger, bSkipPreBuildTargets);
    }

    // WorkingSet 就是用于判断文件是否被迭代的接口，这里创建的是PerforceSourceFileWorkingSet
    // UnrealBuildTool\System\SourceFileWorkingSet.cs
	public static ISourceFileWorkingSet Create(DirectoryReference RootDir, IEnumerable<DirectoryReference> ProjectDirs, ILogger Logger)
    {
        if (Provider == ProviderType.None || ProjectFileGenerator.bGenerateProjectFiles)
        {
            return new EmptySourceFileWorkingSet();
        }
        else if (Provider == ProviderType.Git)
        {
            GitSourceFileWorkingSet? WorkingSet;
            if (!String.IsNullOrEmpty(RepositoryPath))
            {
                WorkingSet = new GitSourceFileWorkingSet(GitPath, DirectoryReference.Combine(RootDir, RepositoryPath), null, Logger);
            }
            else if(!TryCreateGitWorkingSet(RootDir, ProjectDirs, Logger, out WorkingSet))
            {
                WorkingSet = new GitSourceFileWorkingSet(GitPath, RootDir, null, Logger);
            }
            return WorkingSet;
        }
        else if (Provider == ProviderType.Perforce)
        {
            return new PerforceSourceFileWorkingSet();
        }
        else
        {
            GitSourceFileWorkingSet? WorkingSet;
            if(TryCreateGitWorkingSet(RootDir, ProjectDirs, Logger, out WorkingSet))
            {
                return WorkingSet;
            }
            else
            {
                return new PerforceSourceFileWorkingSet();
            }
        }
	}

    // Perforce环境下，判断文件是否unity build的方法
    
	/// <summary>
	/// Queries the working set for files tracked by Perforce.
	/// </summary>
	class PerforceSourceFileWorkingSet : ISourceFileWorkingSet
	{
		/// <summary>
		/// Dispose of the current instance.
		/// </summary>
		public void Dispose()
		{
		}

		/// <summary>
		/// Checks if the given file is part of the working set
		/// </summary>
		/// <param name="File">File to check</param>
		/// <returns>True if the file is part of the working set, false otherwise</returns>
		public bool Contains(FileItem File)
		{
			// Generated .cpp files should never be treated as part of the working set
			if (File.HasExtension(".gen.cpp"))
			{
				return false;
			}

			// Check if the file is read-only
			try
			{
				return !File.Attributes.HasFlag(FileAttributes.ReadOnly);
			}
			catch (FileNotFoundException)
			{
				return false;
			}
		}
	}
```
    

    观察 函数GetAdaptiveFiles(UnrealBuildTool\System\Unity.cs) , 可以发现，所有的被迭代的文件都保存在AdaptiveFiles中。

    Perforce 判断被迭代的办法: cpp是可写的，或者cpp对应的header文件是可写的。

### AdaptiveFiles从unity blob中移除，并单独编译

移除逻辑核心在: GenerateUnityCPPs函数 (UnrealBuildTool\System\Unity.cs) 

单独编译的核心在: CompileFilesWithToolChain函数(UnrealBuildTool\Configuration\UEBuildModuleCPP.cs)

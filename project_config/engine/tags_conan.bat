set conan_path=(conan config get storage.path)
ctags -R -a $conan_path

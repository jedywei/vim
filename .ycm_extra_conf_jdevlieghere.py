# .ycm_extra_conf_jdevlieghere.py
# 2018/03/21 by Jedy.Wei
# This file help YCMDiagnostic and YCMComplete to set up
#   the Warning flags and Include header files searching path. 
#   If there is no completation database specified, it will
#   use '/usr/lib', /usr/include/' and '.' as default include
#   header searching path and add all path declaried on the 
#   ".include_list" file. It first read the .include_list at 
#   the current working dir, then the parent directroy, and
#   so on. 
#       1. compile_commands.json
#       2. .clang_complete
#       3. .../include/ 

import os
import os.path
import fnmatch
import logging
import ycm_core
import re

BASE_FLAGS = [
        '-Wall',
        '-Wextra',
        '-Wno-long-long',
        '-Wno-variadic-macros',
        '-fexceptions',
        '-ferror-limit=10000',
        '-DNDEBUG',
        '-std=c++11',
        '-x', 'c++',
        '-I', '/usr/lib/',
        '-I', '/usr/include/',
        '-I', '.',
        ]

SOURCE_EXTENSIONS = [
        '.cpp',
        '.cxx',
        '.cc',
        '.c',
        '.m',
        '.mm'
        ]

SOURCE_DIRECTORIES = [
        'src',
        'lib'
        ]

HEADER_EXTENSIONS = [
        '.h',
        '.hxx',
        '.hpp',
        '.hh'
        ]

HEADER_DIRECTORIES = [
        'include'
        ]

BUILD_DIRECTORY = 'build';

def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS

def GetCompilationInfoForFile(database, filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            # Get info from the source files by replacing the extension.
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
            # If that wasn't successful, try replacing possible header directory with possible source directories.
            for header_dir in HEADER_DIRECTORIES:
                for source_dir in SOURCE_DIRECTORIES:
                    src_file = replacement_file.replace(header_dir, source_dir)
                    if os.path.exists(src_file):
                        compilation_info = database.GetCompilationInfoForFile(src_file)
                        if compilation_info.compiler_flags_:
                            return compilation_info
        return None
    return database.GetCompilationInfoForFile(filename)

def FindNearest(path, target, build_folder=None):
    candidate = os.path.join(path, target)
    if(os.path.isfile(candidate) or os.path.isdir(candidate)):
        logging.info("Found nearest " + target + " at " + candidate)
        return candidate;

    parent = os.path.dirname(os.path.abspath(path));
    if(parent == path):
        raise RuntimeError("Could not find " + target);

    if(build_folder):
        candidate = os.path.join(parent, build_folder, target)
        if(os.path.isfile(candidate) or os.path.isdir(candidate)):
            logging.info("Found nearest " + target + " in build folder at " + candidate)
            return candidate;

    return FindNearest(parent, target, build_folder)

def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[ len(path_flag): ]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForClangComplete(root):
    try:
        clang_complete_path = FindNearest(root, '.clang_complete')
        clang_complete_flags = open(clang_complete_path, 'r').read().splitlines()
        return clang_complete_flags
    except:
        return None

def FlagsForInclude(root):
    try:
        include_path = FindNearest(root, 'include')
        flags = []
        for dirroot, dirnames, filenames in os.walk(include_path):
            for dir_path in dirnames:
                real_path = os.path.join(dirroot, dir_path)
                flags = flags + ['-I', real_path]
        return flags
    except:
        return None

def FlagsForIncludeList(root):
    try:
        workdir=os.path.abspath(root)
        include_file  = FindNearest(root, '.include_list')
        include_path = os.path.dirname(include_file)
        with open(include_file, 'r') as include_items:
            lines = [line.rstrip() for line in include_items]
            lines = [line for line in lines if line]

        flags = []
        for line in lines:
            if line.startswith('#'):
                pass  # skip the comment line
            elif line.startswith('/'):
                flags += [ '-I', line ]
            elif line.startswith('.'):
                flags += [ '-I', line[2:]]
            else:
                flags += [ '-I', os.path.join(include_path,line) ]
        return flags
    except Exception as e:
        print ("Not fount : " + str(e))
        return None




def FlagsForCompilationDatabase(root, filename):
    try:
        # Last argument of next function is the name of the build folder for
        # out of source projects
        compilation_db_path = FindNearest(root, 'compile_commands.json', BUILD_DIRECTORY)
        compilation_db_dir = os.path.dirname(compilation_db_path)
        logging.info("Set compilation database directory to " + compilation_db_dir)
        compilation_db =  ycm_core.CompilationDatabase(compilation_db_dir)
        if not compilation_db:
            logging.info("Compilation database file found but unable to load")
            return None
        compilation_info = GetCompilationInfoForFile(compilation_db, filename)
        if not compilation_info:
            logging.info("No compilation info for " + filename + " in compilation database")
            return None
        return MakeRelativePathsInFlagsAbsolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_)
    except:
        return None

def FlagsForFile(filename):
    root = os.path.realpath(filename);
    filepath = os.path.dirname( os.path.abspath(filename));
    compilation_db_flags = FlagsForCompilationDatabase(root, filename)
    if compilation_db_flags:
        final_flags = compilation_db_flags
    else:
        final_flags = BASE_FLAGS
        clang_flags = FlagsForClangComplete(root)
        if clang_flags:
            final_flags = final_flags + clang_flags
        include_flags = FlagsForInclude(root)
        if include_flags:
            final_flags = final_flags + include_flags
        include_list_flags = FlagsForIncludeList(root)
        if include_list_flags:
            final_flags = final_flags + include_list_flags
    return {
            'flags': final_flags,
            'include_paths_relative_to_dir': filepath, 
            'do_cache': True
            }


module Node.FS.Extra
  ( copy
  , emptyDir
  , ensureDir
  , ensureFile
  , ensureLink
  , ensureSymlink
  , move
  , pathExists
  , remove
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Path (FilePath)

-- Copy a file or directory. The directory can have contents. Like `cp -r`.
copy :: FilePath -> FilePath -> Aff Unit
copy = compose toAffE <<< runEffectFn2 copy_
foreign import copy_ :: EffectFn2 FilePath FilePath (Promise Unit)

-- Ensures that a directory is empty. Deletes directory contents if the
-- directory is not empty. If the directory does not exist, it is created. The
-- directory itself is not deleted.
emptyDir :: FilePath -> Aff Unit
emptyDir = toAffE <<< runEffectFn1 emptyDir_
foreign import emptyDir_ :: EffectFn1 FilePath (Promise Unit)

-- Ensures that the directory exists. If the directory structure does not exist,
-- it is created. Like `mkdir -p`.
ensureDir :: FilePath -> Aff Unit
ensureDir = toAffE <<< runEffectFn1 ensureDir_
foreign import ensureDir_ :: EffectFn1 FilePath (Promise Unit)

-- Ensures that the file exists. If the file that is requested to be created is
-- in directories that do not exist, these directories are created. If the file
-- already exists, it is **NOT MODIFIED**.
ensureFile :: FilePath -> Aff Unit
ensureFile = toAffE <<< runEffectFn1 ensureFile_
foreign import ensureFile_ :: EffectFn1 FilePath (Promise Unit)

-- Ensures that the link exists. If the directory structure does not exist, it
-- is created.
ensureLink :: FilePath -> FilePath -> Aff Unit
ensureLink = compose toAffE <<< runEffectFn2 ensureLink_
foreign import ensureLink_ :: EffectFn2 FilePath FilePath (Promise Unit)

-- Ensures that the symlink exists. If the directory structure does not exist,
-- it is created.
ensureSymlink :: FilePath -> FilePath -> Aff Unit
ensureSymlink = compose toAffE <<< runEffectFn2 ensureSymlink_
foreign import ensureSymlink_ :: EffectFn2 FilePath FilePath (Promise Unit)

-- Moves a file or directory, even across devices.
move :: FilePath -> FilePath -> Aff Unit
move = compose toAffE <<< runEffectFn2 move_
foreign import move_ :: EffectFn2 FilePath FilePath (Promise Unit)

-- Test whether or not the given path exists by checking with the file system.
-- Like
-- [`fs.exists`](https://nodejs.org/api/fs.html#fs_fs_exists_path_callback), but
-- with a normal callback signature (err, exists). Uses `fs.access` under the
-- hood.
pathExists :: FilePath -> Aff Unit
pathExists = toAffE <<< runEffectFn1 pathExists_
foreign import pathExists_ :: EffectFn1 FilePath (Promise Unit)

-- Removes a file or directory. The directory can have contents. If the path
-- does not exist, silently does nothing. Like `rm -rf`.
remove :: FilePath -> FilePath -> Aff Unit
remove = compose toAffE <<< runEffectFn2 remove_
foreign import remove_ :: EffectFn2 FilePath FilePath (Promise Unit)

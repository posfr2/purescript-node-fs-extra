module Node.FS.Extra
  ( copy
  , emptyDir
  , ensureDir
  , ensureFile
  , ensureLink
  , ensureSymlink
  , move
  , outputFile
  , pathExists
  , remove
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Buffer (Buffer)
import Node.Path (FilePath)

foreign import unsafeRequireFS :: forall r. { |r }
fs ::
  { copy :: EffectFn2 FilePath FilePath (Promise Unit)
  , emptyDir :: EffectFn1 FilePath (Promise Unit)
  , ensureDir :: EffectFn1 FilePath (Promise Unit)
  , ensureFile :: EffectFn1 FilePath (Promise Unit)
  , ensureLink :: EffectFn2 FilePath FilePath (Promise Unit)
  , ensureSymlink :: EffectFn2 FilePath FilePath (Promise Unit)
  , move :: EffectFn2 FilePath FilePath (Promise Unit)
  , outputFile :: EffectFn2 FilePath Buffer (Promise Unit)
  , pathExists :: EffectFn1 FilePath (Promise Boolean)
  , remove :: EffectFn1 FilePath (Promise Unit)
  }
fs = unsafeRequireFS

-- Copy a file or directory. The directory can have contents. Like `cp -r`.
copy :: FilePath -> FilePath -> Aff Unit
copy = compose toAffE <<< runEffectFn2 fs.copy

-- Ensures that a directory is empty. Deletes directory contents if the
-- directory is not empty. If the directory does not exist, it is created. The
-- directory itself is not deleted.
emptyDir :: FilePath -> Aff Unit
emptyDir = toAffE <<< runEffectFn1 fs.emptyDir

-- Ensures that the directory exists. If the directory structure does not exist,
-- it is created. Like `mkdir -p`.
ensureDir :: FilePath -> Aff Unit
ensureDir = toAffE <<< runEffectFn1 fs.ensureDir

-- Ensures that the file exists. If the file that is requested to be created is
-- in directories that do not exist, these directories are created. If the file
-- already exists, it is **NOT MODIFIED**.
ensureFile :: FilePath -> Aff Unit
ensureFile = toAffE <<< runEffectFn1 fs.ensureFile

-- Ensures that the link exists. If the directory structure does not exist, it
-- is created.
ensureLink :: FilePath -> FilePath -> Aff Unit
ensureLink = compose toAffE <<< runEffectFn2 fs.ensureLink

-- Ensures that the symlink exists. If the directory structure does not exist,
-- it is created.
ensureSymlink :: FilePath -> FilePath -> Aff Unit
ensureSymlink = compose toAffE <<< runEffectFn2 fs.ensureSymlink

-- Moves a file or directory, even across devices.
move :: FilePath -> FilePath -> Aff Unit
move = compose toAffE <<< runEffectFn2 fs.move

-- Almost the same as `writeFile` (i.e. it
-- [overwrites](http://pages.citebite.com/v2o5n8l2f5reb)), except that if the
-- parent directory does not exist, it's created.
outputFile :: FilePath -> Buffer -> Aff Unit
outputFile = compose toAffE <<< runEffectFn2 fs.outputFile

-- Test whether or not the given path exists by checking with the file system.
-- Like
-- [`fs.exists`](https://nodejs.org/api/fs.html#fsfsexistspathcallback), but
-- with a normal callback signature (err, exists). Uses `fs.access` under the
-- hood.
pathExists :: FilePath -> Aff Boolean
pathExists = toAffE <<< runEffectFn1 fs.pathExists

-- Removes a file or directory. The directory can have contents. If the path
-- does not exist, silently does nothing. Like `rm -rf`.
remove :: FilePath -> Aff Unit
remove = toAffE <<< runEffectFn1 fs.remove

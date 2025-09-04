{-# LANGUAGE ImportQualifiedPost #-}

module Main where

import Control.DeepSeq (force)
import Control.Exception (evaluate)
import Control.Parallel.Strategies (parList, rseq, using)
import Data.ByteString qualified as BS
import Data.Vector.Unboxed qualified as UV
import Data.Word (Word8)

type PartitionIndex = Word8

type PartitionVector = UV.Vector PartitionIndex

readPartitionImage :: FilePath -> IO PartitionVector
readPartitionImage fp = do
  contents <- BS.readFile fp
  pure (UV.fromList (BS.unpack contents))

main = do
  putStrLn "start"
  pixels <- readPartitionImage "partitions.bin"
  let findPartitionPixels partitionNumber = {-# SCC "findIndices" #-} UV.findIndices (== partitionNumber) pixels
      partitionIndices = [1 .. 18]
      partitionPixelLists :: [UV.Vector Int]
      partitionPixelLists = {-# SCC "partitionPixelLists" #-} findPartitionPixels <$> partitionIndices `using` parList rseq
  pixelLists <- evaluate (force partitionPixelLists)
  putStrLn "done"

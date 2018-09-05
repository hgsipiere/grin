module LiveVariable.LiveVariableSpec where

import System.FilePath

import Grin.Grin

import Test.IO
import Test.Hspec

import AbstractInterpretation.Reduce (evalDataFlowInfo)
import AbstractInterpretation.LiveVariable
import AbstractInterpretation.LVAResult

import LiveVariable.Tests.Util
import LiveVariable.Tests.CaseBackwardPropagationNodes
import LiveVariable.Tests.CaseRestricted
import LiveVariable.Tests.Fields
import LiveVariable.Tests.FunctionCall1
import LiveVariable.Tests.FunctionCall2
import LiveVariable.Tests.HeapCaseMin
import LiveVariable.Tests.HeapCase
import LiveVariable.Tests.HeapSimple
import LiveVariable.Tests.HeapUpdateComplex
import LiveVariable.Tests.HeapUpdateFunCall
import LiveVariable.Tests.HeapUpdateLocal
import LiveVariable.Tests.LitPat
import LiveVariable.Tests.MainNodeRet
import LiveVariable.Tests.NodesSimple
import LiveVariable.Tests.NodesTricky
import LiveVariable.Tests.SumOpt

spec :: Spec
spec = runIO runTests

runTests :: IO ()
runTests = runTestsFrom stackRoot

runTestsGHCi :: IO ()
runTestsGHCi = runTestsFrom stackSrc

runTestsFrom :: FilePath -> IO ()
runTestsFrom fromCurDir = runTestsFromWith fromCurDir calcLiveness
  [ caseRestrictedSrc
  , caseBackwardPropagationNodesSrc
  , fieldsSrc
  , functionCall1Src
  , functionCall2Src
  , heapCaseMinSrc
  , heapCaseSrc
  , heapSimpleSrc
  , heapUpdateComplexSrc
  , heapUpdateFunCallSrc
  , heapUpdateLocalSrc
  , litPatSrc
  , mainNodeRetSrc
  , nodesSimpleSrc
  , nodesTrickySrc
  , sumOptSrc
  ]
  [ caseRestrictedSpec
  , caseBackwardPropagationNodesSpec
  , fieldsSpec
  , functionCall1Spec
  , functionCall2Spec
  , heapCaseMinSpec
  , heapCaseSpec
  , heapSimpleSpec
  , heapUpdateComplexSpec
  , heapUpdateFunCallSpec
  , heapUpdateLocalSpec
  , litPatSpec
  , mainNodeRetSpec
  , nodesSimpleSpec
  , nodesTrickySpec
  , sumOptSpec
  ]

calcLiveness :: Exp -> LVAResult
calcLiveness prog
  | Right lvaProgram <- codeGen prog
  , computer <- evalDataFlowInfo lvaProgram
  = toLVAResult lvaProgram computer

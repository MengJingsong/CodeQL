/* This is an automatically generated file
* @name Hello world
* @kind path-problem
* @problem.severity error
* @precision high
* @id java/example/hello-world
*/
import java
import semmle.code.java.dataflow.FlowSinks
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking //TaintTracking

//TODO: 别忘记对应改workflow中的行数
module MyFlowConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(MethodCall call, int index, AssignExpr aexpr, Expr expr, FieldAccess fa|
      aexpr = expr.getParent*() and
      expr = call.getArgument(index) and
      expr.toString().matches("%DFS_NAMENODE_MAX_CORRUPT_FILE_BLOCKS_RETURNED_KEY") and
      fa = aexpr.getDest() and
      source.asExpr() = fa
    ) 
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1,DataFlow::Node node2) {
    exists(FieldAccess fa1, FieldAccess fa2 |
      fa1.getField() = fa2.getField() and
      node1.asExpr() = fa1 and
      node2.asExpr() = fa2
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(GEExpr ge, GTExpr gt, LEExpr le, LTExpr lt|
      sink.asExpr() = ge.getRightOperand() or
      sink.asExpr() = gt.getRightOperand() or
      sink.asExpr() = le.getRightOperand() or
      sink.asExpr() = lt.getRightOperand()
    )
  }
}


module MyFlow = TaintTracking::Global<MyFlowConfiguration>;
import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select
sink.getNode().asExpr().getParent(),  //得到comparison
sink.getNode().asExpr().getParent().(BinaryExpr).getLeftOperand(), //得到另一边的东西
source,
source.getNode().asExpr().getEnclosingCallable(),//外面的callable method或者constructor
source.getNode().getEnclosingCallable().getLocation(),//所在的具体位置
sink,
sink.getNode().asExpr().getEnclosingCallable(),
sink.getNode().getEnclosingCallable().getLocation() 
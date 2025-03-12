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

  // a = b( method(parameters) )

  // this.z,z
  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(FieldAccess fa |
      pred.asExpr() = fa.getQualifier() and
      succ.asExpr() = fa and 
      pred.getLocation().getFile() = succ.getLocation().getFile() //限定位置
    )
  }

  predicate isSink(DataFlow::Node sink) {
    // 这里可以优化成comparsionExpr
    exists(GEExpr ge, GTExpr gt, LEExpr le, LTExpr lt, EqualityTest eqtest|
      sink.asExpr() = ge.getLeftOperand() or
      sink.asExpr() = gt.getLeftOperand() or
      sink.asExpr() = le.getLeftOperand() or
      sink.asExpr() = lt.getLeftOperand() or 
      sink.asExpr() = eqtest.getLeftOperand()
    )
  }
}


module MyFlow = TaintTracking::Global<MyFlowConfiguration>;
import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select
sink.getNode().asExpr().getParent(), 
sink.getNode().asExpr().getParent().(BinaryExpr).getRightOperand(),  //看另一边的是什么
source,
source.getNode().asExpr().getEnclosingCallable(),
source.getNode().getEnclosingCallable().getLocation(),
sink,
sink.getNode().asExpr().getEnclosingCallable(),
sink.getNode().getEnclosingCallable().getLocation() 
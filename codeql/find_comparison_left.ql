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
      expr.toString().matches("%DFS_NAMENODE_MAX_CORRUPT_FILE_BLOCKS_RETURNED_KEY%") and
      fa = aexpr.getDest() and
      source.asExpr() = fa
    ) 
  }

  // 跨方法来寻找this.z 和 z
  predicate isAdditionalFlowStep(DataFlow::Node node1,DataFlow::Node node2) {
    exists(FieldAccess fa1, FieldAccess fa2 |
      fa1.getField() = fa2.getField() and
      node1.asExpr() = fa1 and
      node2.asExpr() = fa2 and
      fa1.getEnclosingCallable().getFile() = fa2.getEnclosingCallable().getFile() // 限制范围
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(BinaryExpr bexpr, IfStmt ifstmt|
      sink.asExpr() = bexpr.getAChildExpr() and
      ifstmt.getCondition().getAChildExpr*() = bexpr
    )
  }
}


module MyFlow = TaintTracking::Global<MyFlowConfiguration>;
import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select
sink.getNode().asExpr().getParent(), 
source,
source.getNode().asExpr().getEnclosingCallable(),
source.getNode().getEnclosingCallable().getLocation(),
sink,
sink.getNode().asExpr().getEnclosingCallable(),
sink.getNode().getEnclosingCallable().getLocation() 
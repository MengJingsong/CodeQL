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
    exists(ClassInstanceExpr classexpr|
        source.asExpr() = classexpr
    )
  }

  // this.z,z
  predicate isAdditionalFlowStep(DataFlow::Node node1,DataFlow::Node node2) {
    exists(FieldAccess fa1, FieldAccess fa2 |
      fa1.getField() = fa2.getField() and
      node1.asExpr() = fa1 and
      node2.asExpr() = fa2 and
      fa1.getEnclosingCallable().getFile() = fa2.getEnclosingCallable().getFile() // 限制范围
    )
  }

  predicate isSink(DataFlow::Node sink) {

    exists(IfStmt ifstmt, Stmt childstmt, Expr expr|
        ifstmt.getLocation().toString() = "placeholder" and
        childstmt = ifstmt.getAChild() and  //getAChild 会返回所有的Child
        expr.getAnEnclosingStmt() = childstmt and
        sink.asExpr() = expr
    ) 
  }
}


module MyFlow = TaintTracking::Global<MyFlowConfiguration>;
import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select
sink.getNode().asExpr().getParent(), 
sink.getNode().asExpr().getParent().(BinaryExpr).getLeftOperand(), 
source,
source.getNode().asExpr().getEnclosingCallable(),
source.getNode().getEnclosingCallable().getLocation(),
sink,
sink.getNode().asExpr().getEnclosingCallable(),
sink.getNode().getEnclosingCallable().getLocation() 
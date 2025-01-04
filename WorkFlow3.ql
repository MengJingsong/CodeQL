import java
import semmle.code.java.dataflow.FlowSinks
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking //TaintTracking

module MyFlowConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof MethodCall
  }

  predicate isSink(DataFlow::Node sink) {
    exists( BinaryExpr bexpr, Expr expr | 
      bexpr.getRightOperand().toString() = "maxDataLength" and 
      expr = bexpr.getLeftOperand() and
      sink.asExpr() = expr
      )
  }
}


module MyFlow = TaintTracking::Global<MyFlowConfiguration>;
import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select
  source,
  source.getNode().asExpr().getEnclosingCallable(),
  source.getNode().getEnclosingCallable().getDeclaringType(),
  sink,

  sink.getNode().asExpr().getEnclosingCallable(),
  sink.getNode().getEnclosingCallable().getDeclaringType() 
import java
import semmle.code.java.dataflow.FlowSinks
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking //TaintTracking

module MyFlowConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr classexpr |
      source.asExpr() = classexpr   //找到new的class 实例
    )
  }

  predicate isSink(DataFlow::Node sink) { 
    // 只要文件位置的限定, 
    exists(GEExpr ge, GTExpr gt, LEExpr le, LTExpr lt, Expr expr|
        expr.getEnclosingCallable().getLocation().toString() = "placeholder"
        and 
        expr.toString() = "cachedDfsUsedCheckTime"
        and
        (
          ( sink.asExpr() = ge.getLeftOperand() and
            ge.getRightOperand() = expr
          ) 
          or
          ( sink.asExpr() = gt.getLeftOperand() and
            gt.getRightOperand() = expr
          ) 
          or
          ( sink.asExpr() = le.getLeftOperand() and
            le.getRightOperand() = expr
          ) 
          or
          ( sink.asExpr() = lt.getLeftOperand() and
            lt.getRightOperand() = expr
          ) 
        )
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
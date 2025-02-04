import java

from Expr expr, Expr expr2
where
    // 只要文件位置的限定, 
      expr.getEnclosingCallable().getLocation().toString() = "file:///home/runner/work/bulk-builder/bulk-builder/hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/server/datanode/fsdataset/impl/BlockPoolSlice.java:338:8:338:18"
      and 
      expr.toString() = "cachedDfsUsedCheckTime"
      and
      exists(GEExpr ge, GTExpr gt, LEExpr le, LTExpr lt|
      (
        ( expr2 = ge.getLeftOperand() and
          ge.getRightOperand() = expr
        ) 
        or
        ( expr2 = gt.getLeftOperand() and
          gt.getRightOperand() = expr
        ) 
        or
        ( expr2 = le.getLeftOperand() and
          le.getRightOperand() = expr
        ) 
        or
        ( expr2 = lt.getLeftOperand() and
          lt.getRightOperand() = expr
        ) 
      )
      )
select expr, expr.getEnclosingCallable().getLocation(), expr2, expr2.getEnclosingCallable().getLocation()
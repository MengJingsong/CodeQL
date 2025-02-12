import java

from Expr expr, IfStmt ifStmt,ReturnStmt returnStmt
where
    // 只要文件位置的限定, 
      expr.getEnclosingCallable().getLocation().toString() = "file:///home/runner/work/bulk-builder/bulk-builder/hadoop-hdfs-project/hadoop-hdfs/src/main/java/org/apache/hadoop/hdfs/server/datanode/fsdataset/impl/BlockPoolSlice.java:338:8:338:18"
      and 
      expr.toString() = "cachedDfsUsedCheckTime"
      and expr.getAnEnclosingStmt() = ifStmt  //找到向上所有的ifstmt
      and ifStmt.getLocation().getStartLine() = expr.getLocation().getStartLine() //保证是最近的一个ifstmt
      and returnStmt = ifStmt.getThen().getAChild()
select ifStmt, ifStmt.getThen(), returnStmt, expr, expr.getEnclosingCallable().getLocation()
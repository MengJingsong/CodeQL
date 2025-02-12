import java

from Expr expr, IfStmt ifStmt, ClassInstanceExpr classexpr
where
      expr.getEnclosingCallable().getLocation().toString() = "placeholder"
      and 
      expr.toString() = "cachedDfsUsedCheckTime"


      and expr.getAnEnclosingStmt() = ifStmt  //找到向上所有的ifstmt
      and ifStmt.getLocation().getStartLine() = expr.getLocation().getStartLine() //保证是最近的一个ifstmt


      and 
      (
        classexpr.getEnclosingStmt() = ifStmt.getThen().getAChild*()  //newclass 外面的第一个stmt就是ifstmt的child
        or
        classexpr.getEnclosingStmt() = ifStmt.getElse().getAChild*()  //newclass 外面的第一个stmt就是ifstmt的child
      )


select ifStmt, ifStmt.getThen(), classexpr, expr, expr.getEnclosingCallable().getLocation()


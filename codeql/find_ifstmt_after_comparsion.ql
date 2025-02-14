/**
 * 这里的是基于find_creation_in_ifstmt.ql的基础上的, 去除掉了直接的classInstanceExpr的检查, 查找的是ifstmt, 主要提取的是ifstmt
 * 的location
 */
import java

from Expr expr, IfStmt ifStmt
where
      expr.getEnclosingCallable().getLocation().toString() = "placeholder"
      and 
      expr.toString() = "cachedDfsUsedCheckTime"


      and expr.getAnEnclosingStmt() = ifStmt  //找到向上所有的ifstmt
      and ifStmt.getLocation().getStartLine() = expr.getLocation().getStartLine() //保证是最近的一个ifstmt

select ifStmt, ifStmt.getLocation()


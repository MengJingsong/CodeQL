import java

from  BinaryExpr bexpr, Expr lexpr, Expr expr2, Expr rexpr, Expr expr1
where
    //c.hasName("Server") and
    //bexpr.getEnclosingCallable().getEnclosingCallable() = c.getACallable() and
    //assign.getDest() = field and

    exists(MethodCall call, int index,AssignExpr aexpr|
      aexpr = expr1.getParent*() and
      expr1 = call.getArgument(index) and
      expr1.toString().matches("%IPC_MAXIMUM_RESPONSE_LENGTH") and
      call.getMethod().hasName("getInt") and
      expr2 = aexpr.getDest()
    ) 
    and
    ( 
      // 
      bexpr.getRightOperand().toString() = expr2.toString().regexpCapture("this.(\\w+)",1) or
      bexpr.getLeftOperand().toString() = expr2.toString().regexpCapture("this.(\\w+)",1)
    )
    and 
    lexpr = bexpr.getLeftOperand() and
    rexpr = bexpr.getRightOperand() 
    and
    lexpr.getType().toString() != "String" and
    rexpr.getType().toString() != "String"
select
bexpr, expr1, expr1.getEnclosingCallable().getDeclaringType(), lexpr.getType(), lexpr, rexpr.getType(), rexpr
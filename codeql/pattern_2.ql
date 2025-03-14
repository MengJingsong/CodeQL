import java

class TargetIfStmtWithReturn extends IfStmt {
    TargetIfStmtWithReturn() {
        exists (
            ReturnStmt returnStmt |
            this.getElse() = returnStmt.getParent() or
            this.getThen() = returnStmt.getParent()
        ) and
        this.getCondition().getAChildExpr*().toString().matches("%placeholder%") and
        this.getFile().toString().matches("%cachedDfsUsedCheckTime%") and
        this.getLocation().getStartLine() = 9999
    }
}


class INodeFileCreation extends ClassInstanceExpr {
    INodeFileCreation() {
      this.getType().hasName("INodeFile") 
    }
}

predicate functionCallChainWrappingINodeFileCreation(MethodCall call, ClassInstanceExpr newObj, int depth) {
    depth in [0 .. 9] and
    (
        (depth = 0 and newObj.getEnclosingCallable() = call.getCallee()
        ) or (
            depth > 0 and
            exists(MethodCall next |
                call.getCallee() = next.getCaller() and
                functionCallChainWrappingINodeFileCreation(next, newObj, depth - 1)
            )
        )
    )
}


from 
    TargetIfStmtWithReturn targetIf,
    MethodCall funcWrappingINodeFileCreation, INodeFileCreation newObj
where 
    functionCallChainWrappingINodeFileCreation(funcWrappingINodeFileCreation, newObj, 4) and
    targetIf.getParent() = funcWrappingINodeFileCreation.getParent() and
    targetIf.getLocation().getEndLine() < funcWrappingINodeFileCreation.getLocation().getStartLine() and
    not targetIf.getEnclosingCallable().getFile().toString().matches("%Test%")
select
    targetIf.getEnclosingCallable(), 
    targetIf,
    funcWrappingINodeFileCreation, funcWrappingINodeFileCreation.getCallee(), newObj
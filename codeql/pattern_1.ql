import java

// class TargetIfStmt extends IfStmt {
//     TargetIfStmt() {
//         this.getCondition().getAChildExpr*().toString().matches("%maxFsObjects%") and
//         this.getFile().toString().matches("FSNamesystem%")
//     }
// }

class TargetIfStmtWithThrow extends IfStmt {
    TargetIfStmtWithThrow() {
        exists (
            ThrowStmt throwStmt |
            this.getElse() = throwStmt.getParent() or
            this.getThen() = throwStmt.getParent()
        ) and
        this.getCondition().getAChildExpr*().toString().matches("%placeholder%") and
        this.getFile().toString().matches("%cachedDfsUsedCheckTime%")
    }
}

class INodeFileCreation extends ClassInstanceExpr {
    INodeFileCreation() {
      this.getType().hasName("INodeFile") 
    }
}

predicate functionCallChainWrappingIf(MethodCall call, TargetIfStmtWithThrow targetIf, int depth) {
    depth in [0 .. 9] and
    (
        (depth = 0 and targetIf.getEnclosingCallable() = call.getCallee()
        ) or (
            depth > 0 and
            exists(MethodCall next |
                call.getCallee() = next.getCaller() and
                functionCallChainWrappingIf(next, targetIf, depth - 1)
            )
        )
    )
}

predicate functionCallChainWrappingINodeFileCreation(MethodCall call, INodeFileCreation newObj, int depth) {
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

// from 
//     MethodCall funcWrappingINodeFileCreation, INodeFileCreation newObj
// where 
//     functionCallChainWrappingINodeFileCreation(funcWrappingINodeFileCreation, newObj, 1)
// select
//     funcWrappingINodeFileCreation, funcWrappingINodeFileCreation.getCallee(), newObj

// from 
//     MethodCall funcWrappingIf, TargetIfStmt targetIf
// where 
//     functionCallChainWrappingIf(funcWrappingIf, targetIf, 3)
// select
//     funcWrappingIf, funcWrappingIf.getCallee(), targetIf


from 
    MethodCall funcWrappingIf, TargetIfStmtWithThrow targetIf,
    MethodCall funcWrappingINodeFileCreation, INodeFileCreation newObj,
    MethodCall funcWrappingAll
where 
    functionCallChainWrappingIf(funcWrappingIf, targetIf, 0) and
    functionCallChainWrappingINodeFileCreation(funcWrappingINodeFileCreation, newObj, 1) and
    funcWrappingIf.getCaller() = funcWrappingAll.getCallee() and
    funcWrappingINodeFileCreation.getCaller() = funcWrappingAll.getCallee() and
    funcWrappingIf.getLocation().getStartLine() < funcWrappingINodeFileCreation.getLocation().getStartLine() and
    not funcWrappingAll.getFile().toString().matches("%Test%")
select
    funcWrappingAll, 
    funcWrappingIf, funcWrappingIf.getCallee(), targetIf,
    funcWrappingINodeFileCreation, funcWrappingINodeFileCreation.getCallee(), newObj
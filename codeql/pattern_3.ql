import java

class TargetIfStmt extends IfStmt {
    TargetIfStmt() {
        this.getCondition().getAChildExpr*().toString().matches("%maxFsObjects%") and
        this.getFile().toString().matches("FSNamesystem%")
    }
}

// from TargetIfStmt ifStmt
// select ifStmt, ifStmt.getEnclosingCallable()


class INodeFileCreation extends ClassInstanceExpr {
    INodeFileCreation() {
      this.getType().hasName("INodeFile") 
    }
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

from 
TargetIfStmt targetIf,
    MethodCall funcWrappingINodeFileCreation, INodeFileCreation newObj
where
    functionCallChainWrappingINodeFileCreation(funcWrappingINodeFileCreation, newObj, 0) and
    (
        targetIf.getElse() = funcWrappingINodeFileCreation.getParent() or
        targetIf.getThen() = funcWrappingINodeFileCreation.getParent()
    ) and
    not targetIf.getEnclosingCallable().getFile().toString().matches("%Test%")
select
        targetIf.getEnclosingCallable(),
        targetIf,
        funcWrappingINodeFileCreation, funcWrappingINodeFileCreation.getCallee(), newObj



// from 
//     TargetIfStmtWithReturn targetIf,
//     MethodCall funcWrappingINodeFileCreation, INodeFileCreation newObj
// where 
//     functionCallChainWrappingINodeFileCreation(funcWrappingINodeFileCreation, newObj, 4) and
//     targetIf.getParent() = funcWrappingINodeFileCreation.getParent() and
//     targetIf.getLocation().getEndLine() < funcWrappingINodeFileCreation.getLocation().getStartLine() and
//     not targetIf.getEnclosingCallable().getFile().toString().matches("%Test%")
// select
//     targetIf.getEnclosingCallable(), 
//     targetIf,
//     funcWrappingINodeFileCreation, funcWrappingINodeFileCreation.getCallee(), newObj
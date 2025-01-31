import java

from ClassInstanceExpr classexpr
where
    exists(classexpr.getEnclosingCallable()) and
    classexpr.getEnclosingCallable().getDeclaringType().hasQualifiedName("org.apache.hadoop.hdfs.server.namenode", "FSNamesystem")
select classexpr, classexpr.getEnclosingCallable(), classexpr.getEnclosingCallable().getDeclaringType()
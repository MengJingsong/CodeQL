# **CodeQL Analysis for Hadoop Variable Configurations**

## **Overview**

This repository provides CodeQL-based analysis to identify and track occurrences of variable configurations within the Hadoop codebase. Specifically, it detects instances where configuration variables are used in comparisons, enabling further research on potential relationships between configurations and metadata.

The configuration variables are extracted from **`hdfs-default.xml`**, and their literal values are used to search the entire Hadoop codebase.

---

## ** Installation & Setup**

### **1️. Install Conda Environment**
Install the miniconda:

```sh
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```
After installing, close and reopen your terminal application or refresh it by running the following command:
```sh
source ~/miniconda3/bin/activate
```
To initialize conda on all available shells, run the following command:
```sh
conda init --all
```


Ensure you have **Conda** installed, then set up a virtual environment:

```sh
conda create -n <env> python=3.10.13
```

Activate the environment:
```sh
conda activate <env>
```

### **2. Install Required Libraries**
Install necessary dependencies:

```sh
conda install pandas tqdm
```

### **3. Install Codeql and Codeql hadoop database**

 The easiest way is to download Codeql in **VSCode**, it will download the codeql and codeql hadoop database automatically. Then the only thing you need is to find the location of these two and put these in codeql query command.

### **4. Configure CodeQL and CodeQL Database Paths**
The **Python script automatically detects** the CodeQL installation path and the **CodeQL database path**. However, if detection fails, manually edit the following functions in **`workflow.py`**:
- `find_codeql_path()`
- `find_codeql_db_path()`

Modify these functions to explicitly specify the **CodeQL binary and database locations**.

---

## ** Optimizing Query Performance**

### **1️. Detect and Optimize Cartesian Joins**
Use the following command to analyze query execution and identify **Cartesian joins**, which can significantly impact performance:
```sh
codeql analyze ...
```

### **2️. Optimize Query Compilation and Evaluation**
Control CodeQL query execution with the following options:

| **Option** | **Description** |
|------------|----------------|
| `--ram=<MB>` | Set the maximum RAM allocation for the query execution. |
| `--threads <num>` | Configure the number of threads for execution (default: `1`). |
| `--save-cache` | Persist intermediate query results aggressively. |
| `--max-disk-cache=<num>` | Set the maximum disk space usage for intermediate query results. |
| `--compilation-cache-size=<num>` | Define the maximum size for the compilation cache directory. |

---

## ** JVM Performance Tuning for CodeQL**
CodeQL queries are executed via **Java-based Query Evaluator**, meaning **JVM tuning** can significantly impact performance.

| **JVM Option** | **Description** |
|---------------|----------------|
| `-J-Xmx<num>M` | Increase the maximum heap memory allocated to the JVM. |
| `-J-XX:+UseG1GC` | Enable the **G1 Garbage Collector (G1GC)** for optimized GC performance. |

---

## ** Optimizing CodeQL Database Storage**
### **1️ Store CodeQL Database in RAM Disk**
Loading the **CodeQL database (codeql_db)** into **RAM Disk** can significantly reduce **I/O latency**.

Example (`cloudlab` setup):
```sh
mkdir /dev/shm/codeql_db
cp -r ~/codeql_db/* /dev/shm/codeql_db
```
 **Effect**: Faster query execution by reducing disk read latency.

### **2️ Store CodeQL Database on SSD/NVMe**
To utilize **SSD/NVMe** storage:
1. Identify high-speed SSD/NVMe disks:
   ```sh
   lsblk -o NAME,ROTA,TYPE,MOUNTPOINT,SIZE
   ```
2. Locate **ROTA=0** (indicating SSD/NVMe drives, e.g., `nvme0n1`).
3. Move **`codeql_db`** to the identified SSD/NVMe drive:
   ```sh
   mv ~/codeql_db /mnt/nvme0n1/codeql_db
   ```

---

## ** Running the Query**
To execute the workflow:
```sh
python workflow.py
```

### **Workflow Execution Steps**
#### ** Workflow 1**
> *(Detailed workflow steps to be added based on specific use case.)*

---

## ** References**
For a complete list of **CodeQL CLI options**, refer to the official documentation:  
 [CodeQL CLI Manual – Execute Queries](https://docs.github.com/en/code-security/codeql-cli/codeql-cli-manual/execute-queries)

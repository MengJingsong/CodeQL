import os
import platform
import glob
import shutil

current_dir = os.getcwd()

# 定义源文件夹和目标文件夹
current_file_path = os.path.abspath(__file__)
previous_file_path = os.path.dirname(os.path.dirname(current_file_path))

output_forward_csv = os.path.join(current_dir, "csv_forward_results")
output_reverse_csv = os.path.join(current_dir, "csv_reverse_results")
output_forward_ql = os.path.join(current_dir, "ql_forward_results")
output_reverse_ql = os.path.join(current_dir, "ql_reverse_results")
output_forward_bqrs = os.path.join(current_dir, "bqrs_forward_results")
output_reverse_bqrs = os.path.join(current_dir, "bqrs_reverse_results")
potential_forward_result_folder_path = os.path.join(current_dir, "filtered_csv_forward_results")


# Ensure all required directories exist
def ensure_directories_exist(directories):
    for directory in directories:
        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"Created directory: {directory}")
        else:
            print(f"Directory already exists: {directory}")
            
# 自动推导 CodeQL 的安装路径
def get_codeql_path():
    system_name = platform.system()  # 获取操作系统名称

    if system_name == "Darwin":  # macOS 系统
        # macOS 上常见的 CodeQL 路径
        base_path = os.path.expanduser("~/Library/Application Support/Code/User/globalStorage/github.vscode-codeql/")
        possible_paths = [
            os.path.expanduser("~/codeql/codeql"),  # 手动安装路径
            "/usr/local/bin/codeql"  # 全局路径
        ]
        
        # 动态查找 `distribution` 目录
        distribution_glob = os.path.join(base_path, "distribution*/codeql/codeql")
        matching_paths = glob.glob(distribution_glob)
        if matching_paths:
            possible_paths.extend(matching_paths)  # 添加匹配到的路径
    elif system_name == "Linux":
        # linux 上常见的 CodeQL 路径
        base_path = os.path.expanduser("~/.vscode-server/data/User/globalStorage/github.vscode-codeql/")
        possible_paths = [
            os.path.expanduser("~/codeql/codeql"),  # 手动安装路径
            "/usr/local/bin/codeql"  # 全局路径
        ]
        
        # 动态查找 `distribution` 目录
        distribution_glob = os.path.join(base_path, "distribution*/codeql/codeql")
        matching_paths = glob.glob(distribution_glob)
        if matching_paths:
            possible_paths.extend(matching_paths)  # 添加匹配到的路径
    elif system_name == "Windows":
        # Windows 上常见的 CodeQL 路径
        possible_paths = [
            os.path.expanduser("~/AppData/Roaming/CodeQL/codeql"),  # 用户安装路径
            "C:\\Program Files\\CodeQL\\codeql.exe"  # 系统全局路径
        ]
    else:
        raise RuntimeError(f"Unsupported operating system: {system_name}")

    # 检查路径是否存在
    for path in possible_paths:
        if os.path.exists(path):
            print(f"Detected CodeQL path: {path}")
            return path

    raise FileNotFoundError("CodeQL executable not found. Please install CodeQL or specify the path manually.")

def get_codeql_db_path(project_name="apache-hadoop", custome_db = False):

    if not custome_db:
        system_name = platform.system()
        user_home = os.path.expanduser("~")  # 用户主目录
        
        # 不同系统的默认路径前缀
        if system_name == "Darwin":  # macOS
            base_path = os.path.join(user_home, "Library", "Application Support", "Code", "User", "workspaceStorage")
        elif system_name == "Linux":
            base_path = os.path.join(user_home, ".vscode-server", "data", "User", "workspaceStorage")
        elif system_name == "Windows":
            base_path = os.path.join(user_home, "AppData", "Roaming", "Code", "User", "workspaceStorage")
        else:
            raise RuntimeError(f"Unsupported operating system: {system_name}")

        # 搜索 workspaceStorage 下的所有子目录，寻找匹配的项目路径
        if os.path.exists(base_path):
            for subdir in os.listdir(base_path):
                potential_path = os.path.join(base_path, subdir, "GitHub.vscode-codeql", project_name, "codeql_db")
                if os.path.exists(potential_path):
                    print(f"Detected CodeQL database path: {potential_path}")
                    return potential_path

        # 如果未找到路径，抛出异常或提示用户手动输入
        raise FileNotFoundError(f"CodeQL database for project '{project_name}' not found in default locations. "
                                "Please ensure the database exists or specify the path manually.")
    else:
        # 使用自定义数据库路径
        custom_db_path = "/users/Yuang/hadoop_src/hadoop/hadoop-codeql-db"
        if os.path.exists(custom_db_path):
            print(f"Using custom CodeQL database path: {custom_db_path}")
            return custom_db_path
        else:
            raise FileNotFoundError(f"Custom CodeQL database not found at {custom_db_path}. "
                                    "Please check the path or create the database.")
     
    
def move_codeql_db_to_shm(codeql_db_path):
    shm_path = "/dev/shm"
    if not os.path.exists(shm_path):
        raise RuntimeError("/dev/shm does not exist. Ensure you're on a Linux system with shared memory support.")

    #base_name = os.path.basename(codeql_db_path)
    
    for i in range(10):
        new_name = f"codeql_db_{i}"
        new_path = os.path.join(shm_path, new_name)

        if os.path.exists(new_path):
            print(f"Skipping {new_path}, already exists.")
            continue
        
        print(f"Copying {codeql_db_path} to {new_path} ...")
        shutil.copytree(codeql_db_path, new_path)
        print(f"Successfully copied to {new_path}")

            
if __name__ == '__main__':
        # List of all directories to ensure existence
    directories_to_check = [
        output_forward_csv,
        output_reverse_csv,
        output_forward_ql,
        output_reverse_ql,
        output_forward_bqrs,
        output_reverse_bqrs,
        potential_forward_result_folder_path
    ]
    
    # Ensure directories exist
    ensure_directories_exist(directories_to_check)
    # Ensure installed codeql path
    get_codeql_path()
    # Ensure installed codeql database
    codeql_db_path = get_codeql_db_path(custome_db=True)
    move_codeql_db_to_shm(codeql_db_path)
    print("Successful!")
    
    
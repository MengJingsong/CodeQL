import gc

def clear_python_memory():
    print("Clearing Python memory...")
    gc.collect()  # 强制垃圾回收
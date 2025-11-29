# repack_apk.py
import os
import zipfile
import shutil
from pathlib import Path

def create_apk_from_extracted(extracted_dir, output_apk):
    """将提取的APK内容重新打包为APK文件"""
    print(f"开始打包APK: {output_apk}")
    
    with zipfile.ZipFile(output_apk, 'w', zipfile.ZIP_DEFLATED) as apk_zip:
        for root, dirs, files in os.walk(extracted_dir):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, extracted_dir)
                apk_zip.write(file_path, arcname)
                print(f"添加文件: {arcname}")
    
    print(f"APK打包完成: {output_apk}")
    return output_apk

def find_apk_components(temp_dir):
    """查找所有APK文件"""
    apk_files = []
    for root, dirs, files in os.walk(temp_dir):
        for file in files:
            if file.endswith('.apk'):
                apk_files.append(os.path.join(root, file))
    return apk_files

def main():
    TEMP_DIR = "Temp"
    OUTPUT_APK = "bluearchive_repacked.apk"
    
    # 查找所有APK文件
    apk_files = find_apk_components(TEMP_DIR)
    
    if not apk_files:
        print("错误: 未找到APK文件")
        return
    
    print(f"找到APK文件: {apk_files}")
    
    # 选择主APK文件（优先选择包含包名的）
    main_apk = None
    for apk in apk_files:
        if "com.YostarJP" in apk:
            main_apk = apk
            break
    
    if not main_apk:
        main_apk = apk_files[0]
    
    print(f"使用主APK文件: {main_apk}")
    
    # 复制APK文件到输出位置
    shutil.copy2(main_apk, OUTPUT_APK)
    print(f"✅ APK准备完成: {OUTPUT_APK}")

if __name__ == "__main__":
    main()

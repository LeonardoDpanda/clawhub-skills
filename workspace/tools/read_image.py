import subprocess
import sys
import os

def read_image(image_path):
    """
    Extract text from image using tesseract OCR
    Supports: PNG, JPG, JPEG, GIF, WebP, BMP, TIFF
    """
    if not os.path.exists(image_path):
        return f"Error: File not found: {image_path}"
    
    try:
        # Run tesseract with English and Chinese support
        result = subprocess.run(
            ['tesseract', image_path, 'stdout', '-l', 'eng+chi_sim'],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if result.returncode == 0:
            text = result.stdout.strip()
            if text:
                return f"📄 图片中的文字内容：\n\n{text}"
            else:
                return "⚠️ 图片中没有识别到文字（可能是纯图片或文字不清晰）"
        else:
            return f"⚠️ OCR识别失败: {result.stderr}"
            
    except subprocess.TimeoutExpired:
        return "⚠️ OCR处理超时"
    except Exception as e:
        return f"⚠️ 发生错误: {str(e)}"

if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(read_image(sys.argv[1]))
    else:
        print("Usage: python3 read_image.py <image_path>")

import os
import subprocess
from typing import List
from PyPDF2 import PdfReader

def install_package(package):
    subprocess.check_call(["pip", "install", package])

try:
    from PyPDF2 import PdfReader
except ImportError:
    print("PyPDF2 is not installed. Installing now...")
    install_package("PyPDF2")
    from PyPDF2 import PdfReader

def extract_text_from_pdf(pdf_file: str) -> List[str]:
    try:
        with open(pdf_file, "rb") as pdf:
            reader = PdfReader(pdf)
            pdf_text = []

            for page_num in range(len(reader.pages)):
                text_content = reader.pages[page_num].extract_text()
                pdf_text.append(text_content)

            return pdf_text
    except Exception as e:
        print(f"An error occurred while processing {pdf_file}: {e}")
        return []

def main():
    pdf_directory = os.path.expanduser("~/Desktop/CSAR/Civics_PDFs")
    text_directory = os.path.expanduser("~/Desktop/CSAR/Civics_texts")
    
    # Create the text directory if it doesn't exist
    os.makedirs(text_directory, exist_ok=True)

    pdf_files = os.listdir(pdf_directory)
    pdf_files = [file for file in pdf_files if file.endswith(".pdf")]

    for pdf_file in pdf_files:
        pdf_path = os.path.join(pdf_directory, pdf_file)
        text_file_name = os.path.splitext(pdf_file)[0] + ".txt"
        text_path = os.path.join(text_directory, text_file_name)
        
        # Check if text file already exists
        if os.path.exists(text_path):
            print(f"Text file {text_file_name} already exists. Skipping...")
            continue

        print(f"Extracting text from {pdf_file}...")
        extracted_text = extract_text_from_pdf(pdf_path)
        
        # Write extracted text to text file
        with open(text_path, "w") as text_file:
            for text in extracted_text:
                text_file.write(text + "\n")
        
        print(f"Text extracted from {pdf_file} and saved to {text_file_name}")

if __name__ == "__main__":
    main()

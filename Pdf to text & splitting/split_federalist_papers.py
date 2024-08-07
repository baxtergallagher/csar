import os

def split_federalist_papers(input_file: str, output_directory: str):
    os.makedirs(output_directory, exist_ok=True)
    
    with open(input_file, "r") as file:
        content = file.read()
    papers = content.split("FEDERALIST")
    if not papers[0].strip():
        papers = papers[1:]

    for paper in papers:
        paper_lines = paper.strip().split('\n')
        title_line = paper_lines[0]
        title = f"FEDERALIST {title_line.strip()}"
      
        file_name = os.path.join(output_directory, f"{title}.txt")

        with open(file_name, "w") as output_file:
            output_file.write(f"FEDERALIST{paper}")
        
        print(f"Created {file_name}")

def main():
    input_file = os.path.expanduser("~/Desktop/CSAR/Civics_texts/The Federalist Papers (1787-88).txt")
    output_directory = os.path.expanduser("~/Desktop/CSAR/Civics_texts/Individual Federalist Papers")
    
    split_federalist_papers(input_file, output_directory)

if __name__ == "__main__":
    main()

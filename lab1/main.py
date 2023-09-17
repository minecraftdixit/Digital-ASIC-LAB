import re

def count_pattern_occurrences(text, pattern):
    occurrences = re.findall(pattern, text)
    return len(occurrences)

def program1():
    text = input("Enter the input 1 :")
    pattern = "1101"

    count_a = count_pattern_occurrences(text, pattern)
    print(f"testcase 1: a = {count_a} ")

    return count_a

def program2():
    text = input("Enter the input 2 :")
    pattern = "1001"

    count_b = count_pattern_occurrences(text, pattern)
    print(f"testcase 2: b =  {count_b} times.")

    return count_b

def main():
     
    count_a = program1()

     
    count_b = program2()

    total_count = count_a + count_b
    print("\nTotal count of both patterns:", total_count)

if __name__ == "__main__":
    main()

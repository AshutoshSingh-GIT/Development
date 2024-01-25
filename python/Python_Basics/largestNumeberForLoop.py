z = [1,784,3,5,6,9,89]
def find_largest(numbers):
  largest = numbers[0]
  for num in numbers:
    if num > largest:
      largest = num
  return largest

print(find_largest(z))

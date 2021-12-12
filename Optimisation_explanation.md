## Modifying Insert! to operating in constant time
Insert! was redesigned to eliminate any processes that would not operate in O(1) time. 
In doing so, I removed the for loop that was used to check if a point already existed in the dictionary. This was because this process' operating time would increase as we increased values to the dictionary (and was therefore not in O(n) time). 

### Utilising sets to search for a point in O(1) time
In order to check if a point already existed in our dictionary I utilised Julia's set data type. I created a set which will be used to store all of our dictionary's values. When there is a unique point, it will be added to the dictionary as well as the set. In doing so, all the points in our set will be reflective of the points in our dictionary. The set is searched through to determine whether the point already exists. 
Searching through a set using in() operates in O(1) time. I confirmed this using Julia's BenchmarkingTools pkg. 

## Modifying PointSet struct to include set 
PointSet was updated to include our value set (vset), as type Set{Any}. 


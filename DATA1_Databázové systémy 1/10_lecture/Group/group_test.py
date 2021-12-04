# -*- coding: utf-8 -*-
# Experimentální implementace specifikace D:
#   https://www.quicksort.co.uk
#
# Vyžaduje Python verze 2:
#   https://www.python.org/downloads/release/python-2718/

from Dee import *

# Uvažujeme relaci:
result = Relation( ["task_no", "field", "student_name", "score"], [
    {"task_no": 1, "field": "mathematics", "student_name": "Anna", "score": 5},
    {"task_no": 2, "field": "physics", "student_name": "Anna", "score": 2},
    {"task_no": 3, "field": "physics", "student_name": "Anna", "score": 5},
    {"task_no": 1, "field": "mathematics", "student_name": "Bert", "score": 1},
    {"task_no": 3, "field": "physics", "student_name": "Bert", "score": 2},
    {"task_no": 1, "field": "mathematics", "student_name": "Cyril", "score": 4},
    {"task_no": 2, "field": "physics", "student_name": "Cyril", "score": 3},
    {"task_no": 3, "field": "physics", "student_name": "Cyril", "score": 5},
    ])

# Tisk relace:
print result

# Sloučení atributů 'task_no', 'student_name' a 'score' na 'field_result':
print GROUP(result, ["task_no", "student_name", "score"], "field_result")

# Sloučení atributů 'student_name' a 'score' na 'task_result':
print GROUP(result, [ "score", "student_name"], "task_result")

# Sloučením atributů 'task_no', 'field' a 'score' na 'student_result':
print GROUP(result, [ "task_no", "field", "score"], "student_result")


# Pojmenujeme si sloučení atributů 'student_name' a 'score' na 'task_result':
group_result =  GROUP(result, [ "score", "student_name"], "task_result")

# Rozdělení atributu 'task_result':
print UNGROUP(group_result, "task_result")

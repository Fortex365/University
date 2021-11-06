#include <pthread.h>
#include <string>
#include <iostream>
#include <assert.h>
#include <fstream>
using namespace std;


typedef struct tpar
{
    char* fileName;
    int occurancyCount;
} thread_param;


string filter;


bool compare(string name)
{
    string tmp;
    locale localizationFunctionality;

    for (string::size_type i = 0; i < name.length(); ++i)
	{
       tmp += toupper(name[i], localizationFunctionality);
    }

    return tmp[0] == 
	filter[0] && tmp[tmp.length() - 1] == filter[1] ? true : false;
}


void* search(void *args)
{
	int resultCount = 0;

	// Unpacking the arguments from the address
	thread_param *arg = (thread_param*) args;
	string filePath = arg->fileName;

	// Setting up the input file
	ifstream file(filePath);
	if (!file.is_open())
	{
		cout << "Error opening input file" << endl;
        pthread_exit(0);
	}

	string line;
	while (getline(file, line))
	{
		if(compare(line))
		{
			resultCount++;
		}
	}
	file.close();

	// Exiting thread with result in the structure
    arg->occurancyCount = resultCount;
	pthread_exit(0);
}


int main(int argc, char** argv)
{
	// Thread handles
	pthread_t thread1, thread2;

	// Input prefix from keyboard
	cout << "Zadejte prefix: ";
	string pseudoFilter;
	cin >> pseudoFilter;
	
	// Upper filter
	locale localizationFunctionality;

    for (string::size_type i = 0; i < pseudoFilter.length(); ++i)
	{
       filter += toupper(pseudoFilter[i], localizationFunctionality);
    }

	// Creating structure
    thread_param t1, t2;

    char fileName1[] = "Jmena1";
    char fileName2[] = "Jmena2";
    t1.fileName = fileName1;
    t2.fileName = fileName2;

	// Creates and checks if threads were assigned successfully
    int res;

	res = pthread_create(&thread1, NULL, search, (void*)&t1);
	if (0 != res)
	{
		cout << "Thread1 creation failed" << endl;
	}

	res = pthread_create(&thread2, NULL, search, (void*)&t2);
	if (0 != res)
	{
		cout << "Thread2 creation failed" << endl;
        return 0;
	}

	assert(thread1 && thread2);

	// Returning exit codes of each thread implicitly in structure
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

	// Outputting the results
	cout << "Thread-1 result: " << t1.occurancyCount << endl;
	cout << "Thread-2 result: " << t2.occurancyCount;

	// Closing main process
	return 0;
}

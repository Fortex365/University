#include <pthread.h>
#include <semaphore.h>
#include <iostream>
#include <fstream>
#include <climits>
using namespace std;

sem_t item;
sem_t space;

ifstream file_read;
ofstream file_write;

bool signal_done = false;
int traded_number;

void* Produce(void* args)
{
    char byte_first, byte_second;
    int num = 0, already_read = 0;
    int* num_result;

    while(true)
    {
        file_read.read(&byte_first, 1);
        file_read.read(&byte_second, 1);

        if(file_read.eof() || !file_read.good())
        {
            break;
        }

        already_read++;
        num = (byte_second << 8) | byte_first;

        sem_wait(&space);
        traded_number = num;
        num = 0;
        sem_post(&item);
    }

    sem_wait(&space);
    traded_number = 0;
    signal_done = true;
    sem_post(&item);

    file_read.close();

    num_result = (int*)malloc(sizeof(int));
    *num_result = already_read;

    return (void*) num_result;
}


void* Consume(void* args)
{
    char digit, size, part_cnt, bytes[4];
    int written_cnt = 0, num, bcd;
    int* num_res;

    sem_wait(&item);
    while(!signal_done)
    {
        num = traded_number;
        sem_post(&space);

        if(num >= 0)
        {
            bcd = 0xC; 
        }
        else
        {
            num = 0 - num;
            bcd = 0xD;
        }

        part_cnt = 1;

        while(num > 0)
        {
            digit = num % 10;
            num = num / 10;
            bcd = bcd | (digit << (4 * part_cnt++));
        }

        size = (part_cnt + (part_cnt % 2)) / 2;
        bcd = bcd << ((4 - size) * 8);

        bytes[0] = (bcd >> 24) & CHAR_MAX;
        bytes[1] = (bcd >> 16) & CHAR_MAX;
        bytes[2] = (bcd >> 8) & CHAR_MAX;
        bytes[3] = (bcd >> 0) & CHAR_MAX;

        file_write.write(bytes, size);
        written_cnt++;
        sem_wait(&item);
    }

    file_write.close();

    num_res = (int*)malloc(sizeof(int));
    *num_res = written_cnt;

    return (void*) num_res;
}


int main(int argc, char * argv[])
{
    pthread_t produce_thread;
    pthread_t consume_thread;
    int error_code;
    int* returned;

    sem_init(&item, 0, 0);
    sem_init(&space, 0, 1);

    file_read.open("Cisla.bin", ios::binary);
    file_write.open("Cisla.bcd", ios::binary | ios::out);

    if(!file_read.is_open() || !file_write.is_open())
    {
        cout << "Error with opening writing or reading file.";
        return 1;
    }

    error_code = pthread_create(&produce_thread, NULL, Produce, NULL);
    if(error_code != 0)
    {
        cout << "Thread-produce creation has failed! Code: " << error_code;
        return 1;
    }

    error_code = pthread_create(&consume_thread, NULL, Consume, NULL);
    if(error_code != 0)
    {
        cout << "Thread-consume creation has failed! Code: " << error_code;
        return 1;
    }

    pthread_join(produce_thread, (void**)&returned);
    cout << "Thread-produce produced: " << (int)*returned << endl;
    free(returned);

    pthread_join(consume_thread, (void**)&returned);
    cout << "Thread-consume consumed: " << (int)*returned << endl;
    free(returned);

    sem_destroy(&item);
    sem_destroy(&space);
    return 0; 
}

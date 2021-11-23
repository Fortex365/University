#include <pthread.h>
#include <iostream>
#include <unistd.h>
using namespace std;


pthread_mutex_t mutex_wp = PTHREAD_MUTEX_INITIALIZER;
bool time_to_end = false;
time_t time_passer;

void *writer(void *args)
{
    while (true)
    {
        pthread_mutex_lock(&mutex_wp);
        
        if(time_to_end)
        {
            break;
        }
        
        time_passer = time(NULL);
        pthread_mutex_unlock(&mutex_wp);
        usleep(50000);
    }
    
    pthread_mutex_unlock(&mutex_wp);
    pthread_exit(NULL);
}


void *printer(void *args)
{
    int print_count = 0;
    time_t last_printed = 0;
    tm *time_passer_localtime;
    
    while (true)
    {
        pthread_mutex_lock(&mutex_wp);
        
        if (last_printed != time_passer)
        {
            time_passer_localtime = localtime(&time_passer);
            last_printed = time_passer;
            
            cout << time_passer_localtime->tm_hour << ':' << time_passer_localtime->tm_min << ':' << time_passer_localtime->tm_sec << endl;
            
            if(++print_count == 5)
            {
                time_to_end = true;
                break;
            }
        }
        
        pthread_mutex_unlock(&mutex_wp);
        usleep(50000);
    }
    
    pthread_mutex_unlock(&mutex_wp);
    pthread_exit(NULL);
}


int main(int argc, char * argv[])
{
    pthread_t thread_writer, thread_printer;
    int thread_err;
    
    thread_err = pthread_create(&thread_writer, NULL, writer, NULL);
    if(thread_err != 0)
    {
        cout << "Error during thread creation:" << " " << thread_err << endl;
        return 1;
    }
    
    thread_err = pthread_create(&thread_printer, NULL, printer, NULL);
    if(thread_err != 0)
    {
        cout << "Error during thread creation:" << " " << thread_err << endl;
        return 1;
    }
    
    pthread_join(thread_writer, NULL);
    pthread_join(thread_printer, NULL);
    
    return 0;
}

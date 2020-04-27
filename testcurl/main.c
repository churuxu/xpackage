#include "curl/curl.h"
#include <stdio.h>


static size_t http_write_callback(char *ptr, size_t size, size_t nmemb, void *userdata){
	size_t len = size * nmemb;
	fwrite(ptr,size,nmemb,stdout);	
	return len;
}

int main(){
    //SSL_library_init();
    char errmsg[356];
    errmsg[0]=0;
	CURL* handle = curl_easy_init();
	curl_easy_setopt(handle, CURLOPT_URL, "https://www.baidu.com");
	//curl_easy_setopt(handle, CURLOPT_SSL_VERIFYPEER, 0);
	curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION, http_write_callback);	
	curl_easy_setopt(handle, CURLOPT_ERRORBUFFER, errmsg);
    curl_easy_setopt(handle, CURLOPT_CAINFO, "CA.cer");
	int ret = curl_easy_perform(handle);
    if(ret){
        printf(errmsg);
    }
    Sleep(15000);
    return 0;
}

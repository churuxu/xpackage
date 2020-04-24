#include <stdio.h>
#include <string.h>
#include "json.h"

int main(){
	const char* str = "{\"hello\":\"world\"}";
	json_value* jsonobj = json_parse(str, strlen(str));
	const char* val = (*jsonobj)["hello"];
	printf("value:%s\n", val);
	return 0;
}
#include <stdio.h>
#include <string.h>
#include <unistd.h>

__attribute__((constructor))
void __fake_library_init__()
{
    ;
}

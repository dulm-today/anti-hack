#include <stdio.h>
#include <string.h>
#include <unistd.h>

__attribute__((constructor))
void __fake_library_init__()
{
    const char* str = "fake library running\n";
    write(STDERR_FILENO, str, strlen(str));
}

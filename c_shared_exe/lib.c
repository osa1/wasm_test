__attribute__ ((visibility("default")))
int c_fn_2(int x, int y)
{
    return x + y;
}

__attribute__ ((visibility("default")))
int (*c_fn(void)) (int x, int y)
{
    return &c_fn_2;
}

__attribute__ ((visibility("default")))
int array[100] = {0};

__attribute__ ((visibility("default")))
int *array_ptr = array + 50;

__attribute__ ((visibility("default")))
int *get_array_ptr()
{
    return array_ptr;
}

__attribute__ ((visibility("default"))) int c_fn_2(int x, int y)
{
    return x + y;
}

__attribute__ ((visibility("default"))) int (*c_fn(void)) (int x, int y)
{
    return &c_fn_2;
}

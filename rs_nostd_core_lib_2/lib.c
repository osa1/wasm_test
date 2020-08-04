int c_fn(int x, int y)
{
    return x + y;
}

int (*c_fn_2(void)) (int x, int y)
{
    return &c_fn;
}

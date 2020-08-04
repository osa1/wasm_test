int c_fn_2(int x, int y)
{
    return x + y;
}

int (*c_fn(void)) (int x, int y)
{
    return &c_fn_2;
}

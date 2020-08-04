int (*c_fn_2(void))(int x, int y);
int rust_fn(int x, int y);

int main()
{
    rust_fn(5, 10);
    c_fn_2()(10, 15);
    return 0;
}

int (*c_fn(void))(int x, int y);
int (*rust_fn(void))(int x, int y);

int main()
{
    rust_fn()(5, 10);
    c_fn()(10, 15);
    return 0;
}

int c_fn(int x, int y);
int rust_fn(int x, int y);

int main()
{
    rust_fn(5, 10);
    c_fn(10, 15);
    return 0;
}

extern int (*c_fn(void)) (int x, int y);
extern int c_fn_2(int x, int y);
extern int *array;
extern int *array_ptr;
extern int *get_array_ptr(void);

int main()
{
    if (c_fn() != c_fn_2) {
        return 1;
    }

    if (get_array_ptr() != array_ptr) {
        return 1;
    }

    if (array_ptr != array + 50) {
        return 1;
    }

    return 0;
}

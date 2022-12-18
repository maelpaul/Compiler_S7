if [ $# -eq 0 ]
then
    echo "Missing argument"
    exit
elif [ $# -ge 2 ]
then
    echo "Too many arguments"
    exit
else
    make
    ./src/myml tests/$1
    make test
fi

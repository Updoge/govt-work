package ;

class Array2D
{
    public static function create(w:Int, h:Int)
    {
        var array = [];
        for (x in 0...w)
        {
            array[x] = [];
            for (y in 0...h)
            {
                array[x][y] = null;
            }
        }
        return array;
    }
}
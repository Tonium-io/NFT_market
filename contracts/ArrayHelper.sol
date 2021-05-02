pragma ton-solidity >= 0.35.0;

library ArrayHelper {
    // Delete the value from `array` at position `index`
    function del(uint[] array, uint index) internal pure {
        for (uint i = index; i + 1 < array.length; ++i){
            array[i] = array[i + 1];
        }
        array.pop();
    }
}

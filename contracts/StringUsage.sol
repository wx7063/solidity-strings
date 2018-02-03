pragma solidity ^0.4.18;
import "./Lib/StringsLib.sol";

contract StringUsage{
    
    function replace(string str, string a, string b, int count) returns(string){
        return StringsLib.replace(str, a, b, count);
    }
    
    function endWith(string str, string target)returns(bool){
        return StringsLib.endwith(str, target);
    }
    
    function find(string str, string target, uint pos)returns(int){
        return StringsLib.find(str, target, pos);
    }
    
    function remove(string str, string target, int count)returns(string){
        return StringsLib.remove(str, target, count);
    }
    
    function len(string str)returns (uint){
        return StringsLib.len(str);
    }
}


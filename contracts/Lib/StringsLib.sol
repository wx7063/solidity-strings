pragma solidity ^0.4.18;

import "./Unsafe/MemoryLib.sol";

library StringsLib{
    function concat(string r, string l)public  returns(string){
        uint ptr_r;
        uint ptr_l;
        assembly{
            ptr_r := r
            ptr_l := l
        }
        uint ptr = MemoryLib.memcat(ptr_r, ptr_l);
        uint len;
        assembly{
            len := mload(ptr)
        }
        string memory rt;
        assembly{
            rt := ptr
        }
        return rt;
    }    
    
    function find(string str, string target, uint pos)internal  returns(int){
        uint ptr_str;
        uint ptr_target;
        assembly{
            ptr_str := str
            ptr_target := target
        }
        return MemoryLib.find(ptr_str, ptr_target, pos);
    } 

    function remove(string str, string target, int count)internal returns(string){
        uint ptr_str;
        uint ptr_target;
        uint len_target;
        assembly{
            ptr_str := str
            ptr_target := target
            len_target := mload(target)
        }
        for(;;){
            int pos = MemoryLib.find(ptr_str, ptr_target, 0);
            if(pos>=0){
                MemoryLib.memcut(ptr_str, uint(pos), len_target);
                if(count>0){
                    count--;
                    if(count<1){
                        break;
                    }
                }
                continue;
            }
            break;
        }
        return str;
    }    

    function contains(string str, string target)internal returns(bool){
        return find(str, target, 0) > -1;
    }

    function startwith(string str, string target)internal returns(bool){
         return find(str, target, 0) == 0 ;
    }

    function endwith(string str, string target)internal returns(bool){
         uint pos = bytes(str).length-bytes(target).length;
         return find(str, target, pos) == int(pos);  
    }
    
    event P(uint v, string k);
    
    function replace(string str, string a, string b, int count)internal returns(string){
        uint len_a;
        uint len_b;
        uint len_str;
        uint ptr_str;
        uint ptr_a;
        uint ptr_b;
   
        assembly{
            ptr_str := str
            ptr_a := a
            ptr_b := b
            len_a := mload(a)
            len_b := mload(b)
            len_str := mload(str)
        }
        if(len_b == 0){
            return str;
        }
        if(len_str < len_a){
            return str;
        }
        int pos = MemoryLib.find(ptr_str, ptr_a, 0);
        if(pos<0){
            return str;
        }
        if(len_a>=len_b){
            for(
                uint times =0;
                pos>=0; 
                pos = MemoryLib.find(ptr_str, ptr_a, uint(pos)+len_b)
            ){
                MemoryLib.memcpy(ptr_str+0x20 + uint(pos), ptr_b+0x20, len_b);
                MemoryLib.memcpy(ptr_str+0x20+uint(pos)+len_b, ptr_str+0x20+uint(pos)+len_a, len_str-uint(pos)-len_a);
                len_str = len_str - len_a + len_b; 
                assembly{
                    mstore(ptr_str, len_str)
                }
                if(count>0){
                    count--;
                    if(count==0){
                        break;
                    }
                }
                times++;
            }
            return str;
        }else{
            uint ptr  = MemoryLib.calloc(len_str + (len_str/len_a)*(len_b-len_a));
            uint size = 0;
            int last_cpy_pos = 0;
            for( 
                ;
                pos>=0;
                pos = MemoryLib.find(ptr_str, ptr_a, uint(pos)+len_a)
            ){
                MemoryLib.memcpy(ptr+0x20+size, ptr_str+0x20 + uint(last_cpy_pos), uint(pos-last_cpy_pos));
                size += uint(pos-last_cpy_pos);
                MemoryLib.memcpy(ptr+size+0x20, ptr_b+0x20, len_b);
                last_cpy_pos = pos + int(len_a);
                size += uint(len_b);
                if(count>0){
                    count--;
                    if(count==0){
                        break;
                    }
                }
            }
            MemoryLib.memcpy(ptr+0x20+size, ptr_str+0x20+uint(last_cpy_pos), len_str-uint(last_cpy_pos));
            size += len_str-uint(last_cpy_pos);
            assembly{
                mstore(ptr, size)
                str := ptr
            }
        }
        return str;
    }
    
    function len(string str)internal returns(uint){
        uint ptr;
        uint len;
        assembly{
            ptr := add(str, 0x20)
            len := mload(str)
        }
        uint val;
        uint pos;
        uint runes = 0;
        for(;pos<len;){
            assembly{
                val := and(0xff, mload(add(ptr, pos)))
            }
            if (val < 0x80) {
                pos += 1;
            } else if(val < 0xE0) {
                pos += 2;
            } else if(val < 0xF0) {
                pos += 3;
            } else if(val < 0xF8) {
                pos += 4;
            } else if(val < 0xFC) {
                pos += 5;
            } else {
                pos += 6;
            }
            runes++;
        }
        return runes;
    }
}

pragma solidity ^0.4.18;

library MemoryLib{
    function memcpy(uint ptr_dest, uint ptr_src, uint length)internal {
        for(;length>=0x20;length-=0x20){
            assembly{
                mstore(ptr_dest, mload(ptr_src))
                ptr_src := add(ptr_src, 0x20)
                ptr_dest := add(ptr_dest, 0x20)
            }
        }
        assembly{
            let mask := sub(exp(256,  sub(32, length)), 1)
            let a := and(mload(ptr_src), not(mask))
            let b := and(mload(ptr_dest), mask)
            mstore(ptr_dest, or(a, b))
        }
  }    
  
    function memcat(uint ptr_l, uint ptr_r)internal  returns(uint){
        uint len_l;
        uint len_r;
        uint length;
        assembly{
            len_l := mload(ptr_l)
            len_r := mload(ptr_r)
            ptr_l := add(ptr_l, 0x20)
            ptr_r := add(ptr_r, 0x20)
            length := add(len_r, len_l)
        }
        uint rt = calloc(length);
        uint ptr = rt + 32;
        memcpy(ptr, ptr_l, len_l);
        ptr += len_l;
        memcpy(ptr, ptr_r, len_r);
        assembly{
            length := mload(rt)
        }
        return rt;
    }
    
    function memcut(uint ptr, uint pos, uint size)internal{
        uint len;
        assembly{
            len := mload(ptr)
            ptr := add(ptr, 0x20)
        }
        if(len<pos+size){
            return;
        }
        memcpy(ptr+pos, ptr+pos+size, len-size-pos);
        assembly{
            mstore(sub(ptr, 0x20), sub(len,size))
        }
    }
    
    function calloc(uint size)internal  returns(uint ptr){
        assembly{
            ptr := mload(0x40)
            mstore(ptr,  size)
            mstore(0x40, add(ptr, add(size, 0x20)))
        }
        return ptr;         
    }
    
    function find(uint ptr, uint target, uint pos)internal  returns(int){
        uint target_len;
        uint ptr_len;
        
        assembly{
            target_len := mload(target)
            ptr_len := mload(ptr)
            ptr := add(ptr, add(32, pos))
            target := add(target, 0x20)
        }
        if(pos>ptr_len || target_len+pos>ptr_len){
            return -1;
        }
        uint find_end = ptr_len - target_len+1;
        if(target_len>32){
            assembly{
                    let hash_target := sha3(target, target_len)
                LOOP: 
                    jumpi(END, eq(sha3(ptr, target_len), hash_target)) 
                    ptr := add(ptr, 1)
                    pos := add(pos, 1)
                    jumpi(LOOP,  lt(pos, find_end))
            	END:    
                }
            if(pos<find_end){
                return int(pos);
            }
        }else{
            uint target_val;
            uint mask = ~(256**(32-target_len) - 1); 
            assembly{
                target_val := and(mload(target), mask)
            }
            uint ptr_val;
            for(;pos<find_end; pos++){
                assembly{
                    ptr_val := and(mload(ptr), mask)
                    ptr := add(ptr, 1)
                }
                if(target_val == ptr_val){
                    return int(pos);
                }
            }
        }
        return -1;
    }
}


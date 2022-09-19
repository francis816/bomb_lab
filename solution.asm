
phase 5

0000000000401062 <phase_5>:


401062:   53                      push   %rbx                         // save original value in rbx into stack, so rbx is empty and can be used now 
401063:   48 83 ec 20             sub    $0x20,%rsp                   // allocate 32 bytes 
401067:   48 89 fb                mov    %rdi,%rbx                    // rbx = 1st param
40106a:   64 48 8b 04 25 28 00    mov    %fs:0x28,%rax                // get the canary value
401071:   00 00
401073:   48 89 44 24 18          mov    %rax,0x18(%rsp)              // save the canary value into stack top + 24th 
401078:   31 c0                   xor    %eax,%eax                    // reset eax to 0
40107a:   e8 9c 02 00 00          call   40131b <string_length>       
40107f:   83 f8 06                cmp    $0x6,%eax                    // see the length of 1st param
401082:   74 4e                   je     4010d2 <phase_5+0x70>        // eax = 6 so 1st param length = 6
401084:   e8 b1 03 00 00          call   40143a <explode_bomb>
401089:   eb 47                   jmp    4010d2 <phase_5+0x70>       
40108b:   0f b6 0c 03             movzbl (%rbx,%rax,1),%ecx           // use p *(char *)($rbx) to see what rbx is. And (at the beg.), you realize it is the array, aka the 1st element, and rax is the offset 
                                                                      // p *(char *)($rbx + 0x1) should be the 2nd element

40108f:   88 0c 24                mov    %cl,(%rsp)                   // we only move the lower byte of %ecx to stack top. lowerst byte is enough because a char is 1 byte
401092:   48 8b 14 24             mov    (%rsp),%rdx                  // move the lower byte value to rdx. rdx = 97
401096:   83 e2 0f                and    $0xf,%edx                    // mask rdx with 1111. e.g. 'a' = 97, 0110 0001 & 0000 1111, and we get 0000 0001. mask with 0xf means we only take the lower 4 bits. rdx = 1
                                                                      // 1st time: 1111 & 0110 0001 = >>>  1, aka 1, so we take 0x4024b0 + 1 => 'a'
                                                                      // 2nd time: 1111 & 0110 0010 = >>> 10, aka 2, so we take 0x4024b0 + 2 => 'a'
                                                                      // 3rd time: 1111 & 0110 0011 = >>> 11, aka 3, so 0x4024b0 + 3
                                                                      // 4th time: 1111 & 0110 0100 = >>> 100, aka 4, so 0x4024b4 
                                                                         
401099:   0f b6 92 b0 24 40 00    movzbl 0x4024b0(%rdx),%edx          // move the val at location (0x0001 + 0x4024b0) to %edx. using x/s 0x4024b1, we see that it is pointing at another 'a'
4010a0:   88 54 04 10             mov    %dl,0x10(%rsp,%rax,1)        // store 'a' at stack top + 16 bytes offset 
4010a4:   48 83 c0 01             add    $0x1,%rax                    // increment i by 1
4010a8:   48 83 f8 06             cmp    $0x6,%rax                    // continue looping until rax reaches 6
4010ac:   75 dd                   jne    40108b <phase_5+0x29>        // then you get "aduier"
4010ae:   c6 44 24 16 00          movb   $0x0,0x16(%rsp)              // at 21st offset from stack top = 'r' from above, set 22nd = 0, aka the end of string
4010b3:   be 5e 24 40 00          mov    $0x40245e,%esi               // x/s 0x40245e = "flyers" = esi
4010b8:   48 8d 7c 24 10          lea    0x10(%rsp),%rdi              // "aduier" = rdi
4010bd:   e8 76 02 00 00          call   401338 <strings_not_equal>   // if strings are """"not"""" equal, then return 1, aka if they are the same =  returns 0
                                                                      
																	  // *********** since "aduier" != "flyers", and "aduier" comes from our input of "abcdef"
																	  // so we need to input 6 chars to make the string at 0x402450 to store "flyers" not "aduier"

4010c2:   85 c0                   test   %eax,%eax                 
4010c4:   74 13                   je     4010d9 <phase_5+0x77>        // if = 0, aka equal,jump
4010c6:   e8 6f 03 00 00          call   40143a <explode_bomb>        
4010cb:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
4010d0:   eb 07                   jmp    4010d9 <phase_5+0x77>
4010d2:   b8 00 00 00 00          mov    $0x0,%eax                    // reset eax to 0
4010d7:   eb b2                   jmp    40108b <phase_5+0x29>        
4010d9:   48 8b 44 24 18          mov    0x18(%rsp),%rax              // move value at stack top + 24 offset to rax 
4010de:   64 48 33 04 25 28 00    xor    %fs:0x28,%rax                // xor canery with value at stack top + 24 offset. If = 0 means they are the same, means canery is untouched, aka no buffer overlow *******
4010e5:   00 00
4010e7:   74 05                   je     4010ee <phase_5+0x8c>        // equals 0 so jump
4010e9:   e8 42 fa ff ff          call   400b30 <__stack_chk_fail@plt>// otherwise call stack fail
4010ee:   48 83 c4 20             add    $0x20,%rsp                   // deallocate stack
4010f2:   5b                      pop    %rbx                         // pop back original rbx val 
4010f3:   c3                      ret


/*
"abcdef" = 97 - 102, and will become 1-6 after masking the last 4 bits 

"maduiersnfotvbylSo you think you can stop the bomb with ctrl-c, do you?"
      567 9   1415


9 15 14 5 6 7 
i  o  n e f g      (we know 5 = e, then we just keep counting alphabets)


j = 10
k = 11
l = 12
m = 13
n = 14

one possible answer = "ionefg"
*/

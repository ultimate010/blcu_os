/*
   被Zaks Wang简化成现在这样
   2013-5-20
   Author: Wenbo Yang <solrex@gmail.com> <http://solrex.cn>

   This file is part of the source code of book "Write Your Own OS with Free
   and Open Source Software". Homepage @ <http://share.solrex.cn/WriteOS/>.

   This file is licensed under the GNU General Public License; either
   version 3 of the License, or (at your option) any later version. */

SECTIONS
{
  . = 0x100;
  .text :
  {
    _ftext = .;
  } = 0
}
